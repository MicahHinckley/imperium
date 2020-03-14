use std::process::Command;
use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    command: String,
    name: String
}

fn main() {
    let args = Cli::from_args();

    if args.command == "new" {
        let mut directory = String::from("/");
        directory.push_str(&args.name);

        let result = std::fs::create_dir(directory);
        match result {
            Ok(_) => {},
            Err(error) => { println!("{}", error); }
        }

        // let path = std::fs::canonicalize(format!("../{}", &args.name));
        let mut cmd = Command::new("git");
        cmd.current_dir(format!("./{}", &args.name));
        cmd.arg("init");
    }
}