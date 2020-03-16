use std::{
    fs::{self, File},
    process::{Command},
    io::prelude::*
};

use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    command: String,
    name: String
}

static PROJECT: &str = include_str!("../templates/default.project.json");

fn main() {
    let args = Cli::from_args();

    if args.command == "new" {
        let path = format!("./{}", &args.name);
        let result = fs::create_dir(&path);
        match result {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        let mut cmd = Command::new("git");
        cmd.current_dir(&path);
        cmd.arg("init");

        match cmd.output() {
            Ok(_) => {}
            Err(e) => {
                println!("{}", e);
            }
        }

        let mut cmd = Command::new("git");
        cmd.current_dir(&path);
        cmd.arg("submodule");
        cmd.arg("add");
        cmd.arg("https://github.com/MicahHinckley/imperium");
        cmd.arg("dependencies/imperium");

        match cmd.output() {
            Ok(_) => {}
            Err(e) => {
                println!("{}", e);
            }
        }

        match fs::create_dir_all(format!("{}/{}", path, "src/client")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        match fs::create_dir_all(format!("{}/{}", path, "src/server")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        match fs::create_dir_all(format!("{}/{}", path, "src/shared")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        let contents = PROJECT.replace("replace", &args.name);

        let mut file = File::create("default.project.json").expect("Can't create file!");
        file.write_all(contents.as_bytes()).expect("Can't write to file.");
    }
}