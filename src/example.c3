module example;

import std::io;
import argparser;

fn int main(String[] args)
{
    Option[] options =
    {
        {
            .short_name = 'v',
            .long_name = "version",
            .description = "Displays the version",
            .has_arg = false,
            .required = false
        },
        {
            .short_name = 'i',
            .long_name = "install",
            .description = "Installs the specified library",
            .has_arg = true,
            .required = true
        }
    };
    ArgParser parser =
    {
        args,
        options
    };

    parser.parse();

    if (parser.has_arg("i"))                       // ArgParser.has_arg("install") also works
    {
        handle_install(parser.get_arg("i"));       // ArgParser.get_arg("install") also works
    }

    return 0;
}

fn void handle_install(Sting package_name)
{
    io::printfn("Package name specified: '%s'", package_name);
}