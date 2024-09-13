mod members;

use members::WEBRING_MEMBERS;
use ntex::{http::{header, Response}, web::{self, middleware}};
use ntex_files as nfs;
use ::rand::{thread_rng, Rng};

#[web::get("/next/{name}")]
async fn next(name: web::types::Path<String>) -> impl web::Responder {
    if let Some((i, _)) = WEBRING_MEMBERS.iter().enumerate().find(|(_, member)| member.name == *name) {
        let next_index = (i + 1) % WEBRING_MEMBERS.len();
        let next_domain = WEBRING_MEMBERS[next_index].domain;
        let next_url = format!("https://{next_domain}/");

        return Response::PermanentRedirect()
            .header(header::LOCATION, next_url)
            .take();
    }

    Response::TemporaryRedirect()
        .header(header::LOCATION, "https://nixwebr.ing/")
        .take()
}

#[web::get("/prev/{name}")]
async fn prev(name: web::types::Path<String>) -> impl web::Responder {
    if let Some((i, _)) = WEBRING_MEMBERS.iter().enumerate().find(|(_, member)| member.name == *name) {
        let prev_index = if i == 0 { WEBRING_MEMBERS.len() - 1 } else { i - 1 };
        let prev_domain = WEBRING_MEMBERS[prev_index].domain;
        let prev_url = format!("https://{prev_domain}/");

        return Response::PermanentRedirect()
            .header(header::LOCATION, prev_url)
            .take();
    }

    Response::TemporaryRedirect()
        .header(header::LOCATION, "https://nixwebr.ing/")
        .take()
}

#[web::get("/rand")]
async fn rand() -> impl web::Responder {
    let rand_index = thread_rng().gen_range(0..WEBRING_MEMBERS.len());
    let rand_domain = WEBRING_MEMBERS[rand_index].domain;
    let rand_url = format!("https://{rand_domain}/");

    Response::PermanentRedirect()
        .header(header::LOCATION, rand_url)
        .take()
}

#[ntex::main]
async fn main() -> std::io::Result<()> {
    env_logger::init();

    let nix_webring_dir = std::env::var("NIX_WEBRING_DIR")
        .expect("NIX_WEBRING_DIR not found");

    let nix_webring_port = std::env::var("NIX_WEBRING_PORT")
        .expect("NIX_WEBRING_PORT not found")
        .parse::<u16>()
        .expect("NIX_WEBRING_PORT has to be u16");

    web::server(move || {
        web::App::new()
            .wrap(middleware::Logger::default())
            .service(
                web::scope("/")
                    .service(next)
                    .service(prev)
                    .service(rand)
                    .service(
                        nfs::Files::new("/", nix_webring_dir.clone())
                            .index_file("index.html")
                            .redirect_to_slash_directory()
                    )
            )
    })
    .bind(("127.0.0.1", nix_webring_port))?
    .run()
    .await
}
