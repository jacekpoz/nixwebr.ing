use std::fs::{self};

use ntex::{http::{header, Response}, web::{self, middleware}};
use ntex_files as nfs;
use ::rand::{thread_rng, Rng};
use serde::{Deserialize, Serialize};

#[derive(Clone, Serialize, Deserialize)]
struct WebringMember {
    name: String,
    domain: String,
}

#[web::get("/next/{name}")]
async fn next(
    members: web::types::State<Vec<WebringMember>>,
    name: web::types::Path<String>,
) -> impl web::Responder {
    if let Some((i, _)) = members.iter().enumerate().find(|(_, member)| member.name == *name) {
        let next_index = (i + 1) % members.len();
        let next_domain = &members[next_index].domain;
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
async fn prev(
    members: web::types::State<Vec<WebringMember>>,
    name: web::types::Path<String>,
) -> impl web::Responder {
    if let Some((i, _)) = members.iter().enumerate().find(|(_, member)| member.name == *name) {
        let prev_index = if i == 0 { members.len() - 1 } else { i - 1 };
        let prev_domain = &members[prev_index].domain;
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
async fn rand(
    members: web::types::State<Vec<WebringMember>>,
) -> impl web::Responder {
    let rand_index = thread_rng().gen_range(0..members.len());
    let rand_domain = &members[rand_index].domain;
    let rand_url = format!("https://{rand_domain}/");

    Response::PermanentRedirect()
        .header(header::LOCATION, rand_url)
        .header(header::CACHE_CONTROL, "no-store")
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
        let path = format!("{nix_webring_dir}/webring.json");
        let json = fs::read_to_string(&path)
            .expect(&format!("couldn't open {path}"));

        let members: Vec<WebringMember> = serde_json::from_str(&json)
            .expect(&format!("failed deserializing webring members: {json}"));

        web::App::new()
            .wrap(middleware::Logger::default())
            .state(members)
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
