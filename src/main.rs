use std::{fs, fs::File, path::Path, process::Command, result::Result, io::Error, io::Write};
use structopt::StructOpt;

static PROJECT: &str = include_str!("../templates/default.project.json");

#[derive(StructOpt)]
enum Subcommand {
    #[structopt(name = "new")]
    New {
        name: String
    }
}

fn try_git_init(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("init").current_dir(path).output()?;

    Ok(())
}

fn try_add_dependency(path: &Path) -> Result<(), Error> {
    Command::new("git").arg("submodule").arg("add").arg("https://github.com/MicahHinckley/imperium").arg("dependencies/imperium").current_dir(path).output()?;

    Ok(())
}

fn new(name: &str) -> Result<(), Error> {
    let path = format!("./{}", name);
    let base_path = Path::new(&path);

    println!("{}", base_path.display());

    fs::create_dir_all(&base_path)?;

    println!("{}", base_path.display());

    try_git_init(&base_path)?;
    try_add_dependency(&base_path)?;

    println!("{}", base_path.display());

    let src = base_path.join("src");
    fs::create_dir_all(&src)?;

    println!("{}", base_path.display());

    let src_shared = src.join("shared");
    fs::create_dir_all(src.join(&src_shared))?;

    println!("{}", base_path.display());

    let src_server = src.join("server");
    fs::create_dir_all(src.join(&src_server))?;

    println!("{}", base_path.display());

    let src_client = src.join("client");
    fs::create_dir_all(src.join(&src_client))?;

    println!("{}", base_path.display());

    let contents = PROJECT.replace("replace", name);
    let mut file = File::create(base_path.join("/default.project.json"))?;
    file.write_all(contents.as_bytes())?;

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
            };
        }
    }
}