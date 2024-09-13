// this is hilariously bad but I'm too lazy to do anything about it right now
pub struct WebringMember {
    pub name: &'static str,
    pub domain: &'static str,
}

pub const WEBRING_MEMBERS: &'static [WebringMember] = &[
    WebringMember {
        name: "poz",
        domain: "jacekpoz.pl",
    },
    WebringMember {
        name: "krizej",
        domain: "krizej.codeberg.page",
    },
];
