use std::{fs, fs::File, path::Path, process::Command, result::Result, io::Error, io::Write};
use structopt::StructOpt;

static PROJECT: &str = include_str!("../templates/default.project.json");
static CLIENT_INIT: &str = include_str!("../templates/init.client.lua");
static SERVER_INIT: &str = include_str!("../templates/init.server.lua");
static GIT_IGNORE: &str = include_str!("../templates/gitignore.txt");
static SELENE_CONFIG: &str = include_str!("../templates/selene.toml");

#[derive(StructOpt)]
enum Subcommand {
    #[structopt(name = "new")]
    New {
        name: String
    },
    #[structopt(name = "init")]
    Init,
    #[structopt(name = "update")]
    Update
}

fn try_git_init(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("init").current_dir(path).output()?;

    Ok(())
}

fn try_add_dependency(root: &Path, path: &str, link: &str) -> Result<(), Error> {
    Command::new("git").arg("submodule").arg("add").arg(link).arg(path).current_dir(root).output()?;

    Ok(())
}

fn try_add_dependencies(path: &Path) -> Result<(), Error> {
    try_add_dependency(path, "dependencies/imperium", "https://github.com/Nezuo/imperium")?;
    try_add_dependency(path, "dependencies/import", "https://github.com/Nezuo/import")?;
    try_add_dependency(path, "dependencies/roact", "https://github.com/Roblox/roact")?;
    try_add_dependency(path, "dependencies/rodux", "https://github.com/Roblox/rodux")?;
    try_add_dependency(path, "dependencies/roact-rodux", "https://github.com/Roblox/roact-rodux")?;
    try_add_dependency(path, "dependencies/t", "https://github.com/osyrisrblx/t")?;

    Ok(())
}

fn try_git_update(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("submodule").arg("update").arg("--remote").current_dir(path).output()?;

    Ok(())
}

fn try_create_src(path: &Path) -> Result<(), Error> {
    let src = path.join("src");
    fs::create_dir_all(&src)?;

    fs::create_dir_all(&src.join("shared"))?;

    let src_client = src.join("client/Systems");
    fs::create_dir_all(&src_client)?;

    let src_server = src.join("server/Systems");
    fs::create_dir_all(&src_server)?;

    let mut client_file = File::create(src_client.join("init.client.lua"))?;
    client_file.write_all(CLIENT_INIT.as_bytes())?;
    
    let mut server_file = File::create(src_server.join("init.server.lua"))?;
    server_file.write_all(SERVER_INIT.as_bytes())?;

    Ok(())
}

fn try_create_project(path: &Path, name: &str) -> Result<(), Error> {
    let contents = PROJECT.replace("replace", name);
    let mut file = File::create(path.join("default.project.json"))?;
    file.write_all(contents.as_bytes())?;

    Ok(())
}

fn try_create_git_ignore(path: &Path) -> Result<(), Error> {
    let mut file = File::create(path.join(".gitignore"))?;
    file.write_all(GIT_IGNORE.as_bytes())?;

    Ok(())
}

fn try_create_selene_config(path: &Path) -> Result<(), Error> {
    let mut file = File::create(path.join("selene.toml"))?;
    file.write_all(SELENE_CONFIG.as_bytes())?;

    Ok(())
}

fn new(name: &str) -> Result<(), Error> {
    let path = format!("./{}", name);
    let base_path = Path::new(&path);

    fs::create_dir_all(&base_path)?;

    try_create_src(&base_path)?;

    try_create_project(&base_path, name)?;

    try_create_git_ignore(&base_path)?;
    try_create_selene_config(&base_path)?;

    try_git_init(&base_path)?;
    try_add_dependencies(&base_path)?;

    Ok(())
}

fn init() -> Result<(), Error> {
    let base_path = Path::new("./");

    try_create_src(&base_path)?;

    let canonicalized_path = &base_path.canonicalize().expect("Could not canonicalize base path.");
    let file_name = canonicalized_path.file_name().expect("Could not find file name.").to_string_lossy();
    try_create_project(&base_path, &file_name)?;

    try_create_git_ignore(&base_path)?;
    try_create_selene_config(&base_path)?;

    try_git_init(&base_path)?;
    try_add_dependencies(&base_path)?;

    Ok(())
}

fn update() -> Result<(), Error> {
    let base_path = Path::new("./");

    try_git_update(&base_path)?;

    Ok(())
}

fn main() {
    match Subcommand::from_args() {
        Subcommand::New { name } => {
            match new(&name) {
                Err(error) => {
                    panic!("[ERROR]: {}", error);
                },
                Ok(_) => ()
            }
        },
        Subcommand::Init => {
            match init() {
                Err(error) => {
                    panic!("[ERROR]: {}", error);
                },
                Ok(_) => ()
            }
        },
        Subcommand::Update => {
            match update() {
                Err(error) => {
                    panic!("[ERROR]: {}", error);
                },
                Ok(_) => ()
            }
        }
    }
}