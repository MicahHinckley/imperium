use std::{
    fs::{self},
    process::{Command}
};

use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    command: String,
    name: String
}

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

        cmd.arg("submodule add https://github.com/MicahHinckley/imperium");

        match cmd.output() {
            Ok(_) => {}
            Err(e) => {
                println!("{}", e);
            }
        }

        match fs::create_dir_all(format!("{}, {}", path, "src/client")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        match fs::create_dir_all(format!("{}, {}", path, "src/server")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        match fs::create_dir_all(format!("{}, {}", path, "src/shared")) {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }
    }
}