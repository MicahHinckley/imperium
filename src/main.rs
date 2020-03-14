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
        cmd.current_dir(path);
        cmd.arg("init");
    }
}