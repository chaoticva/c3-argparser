# Disclaimer

### This is a minimal argument parser that is not intended to get expanded with more features.
### for a more feature-packed version see https://github.com/joshring/argparse

# Example

```cpp
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
```
