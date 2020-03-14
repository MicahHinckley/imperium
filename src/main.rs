use structopt::StructOpt;

#[derive(StructOpt)]
struct Cli {
    command: String,
    name: String
}

fn main() {
    let args = Cli::from_args();
    
}