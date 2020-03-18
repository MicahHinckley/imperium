use std::{fs, fs::File, path::Path, process::Command, result::Result, io::Error, io::Write};
use structopt::StructOpt;

static PROJECT: &str = include_str!("../templates/default.project.json");

#[derive(StructOpt)]
enum Subcommand {
    #[structopt(name = "new")]
    New {
        name: String
    },
    #[structopt(name = "init")]
    Init
}

fn try_git_init(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("init").current_dir(path).output()?;

    Ok(())
}

fn try_add_dependency(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("submodule").arg("add").arg("https://github.com/MicahHinckley/imperium").arg("dependencies/imperium").current_dir(path).output()?;

    Ok(())
}

fn try_create_src(path: &Path) -> Result<(), Error> {
    let src = path.join("src");
    fs::create_dir_all(&src)?;

    fs::create_dir_all(&src.join("shared"))?;
    fs::create_dir_all(&src.join("server"))?;
    fs::create_dir_all(&src.join("client"))?;

    Ok(())
}

fn try_create_project(path: &Path, name: &str) -> Result<(), Error> {
    let contents = PROJECT.replace("replace", name);
    let mut file = File::create(path.join("default.project.json"))?;
    file.write_all(contents.as_bytes())?;

    Ok(())
}

fn new(name: &str) -> Result<(), Error> {
    let path = format!("./{}", name);
    let base_path = Path::new(&path);

    fs::create_dir_all(&base_path)?;

    try_git_init(&base_path)?;
    try_add_dependency(&base_path)?;

    try_create_src(&base_path)?;

    try_create_project(&base_path, name)?;

    Ok(())
}

fn init() -> Result<(), Error> {
    let base_path = Path::new("./");

    try_git_init(&base_path)?;
    try_add_dependency(&base_path)?;

    try_create_src(&base_path)?;
    
    let name = &base_path.canonicalize().expect("Could not canonicalize base path.").file_name().expect("Could not find file name.").to_str().expect("Could not convert to `&str`")
    try_create_project(&base_path, name)?;

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
        }
    }
}