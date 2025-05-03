/*
  Copyright 2025 Kiana Bennett

  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
  and associated documentation files (the “Software”), to deal in the Software without
  restriction, including without limitation the rights to use, copy, modify, merge, publish,
  distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
  Software is furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all copies or
  substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
  ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
  OTHER DEALINGS IN THE SOFTWARE.
*/

module argparser;

import color_util;
import std::io;
import std::os;

const int EXIT_SUCCESS = 0;
const int EXIT_FAILURE = 1;

struct Option
{
    char   short_name;
    String long_name;
    String description;
    bool   has_arg;
    bool   required;
    String value;
}

struct ArgParser
{
    String[] args;
    Option[] options;
}

fn String ArgParser.get_arg(&self, String name)
{
    for (int i = 0; i < self.options.len; i++)
    {
        if (name == self.options[i].long_name || (name.len == 1 && name[0] == self.options[i].short_name))
        {
            return self.options[i].value;
        }
    }

    io::eprintfn("%sArgument '%s' is not defined%s", color_util::COLOR_RED, name, color_util::COLOR_RESET);
    os::exit(EXIT_FAILURE);
    return "";
}

fn bool ArgParser.has_arg(&self, String name)
{
    for (int i = 0; i < self.options.len; i++)
    {
        if (name == self.options[i].long_name || (name.len == 1 && name[0] == self.options[i].short_name))
        {
            return self.options[i].value != "";
        }
    }
    return false;
}

fn void ArgParser.parse(&self)
{
    for (int i = 1; i < self.args.len; i++)
    {
        String arg = self.args[i];

        if (arg == "--help" || arg == "-h")
        {
            self.print_usage();
            os::exit(EXIT_SUCCESS);
        }

        for (int j = 0; j < self.options.len; j++)
        {
            bool is_long = arg.starts_with("--") && arg[2..] == self.options[j].long_name;
            bool is_short = arg.starts_with("-") && !arg.starts_with("--") &&  arg[1] == self.options[j].short_name && arg.len == 2;

            if (is_long || is_short)
            {
                if (self.options[j].has_arg)
                {
                    if (i + 1 >= self.args.len)
                    {
                        io::eprintfn("%sOption '%s' requires an argument%s", color_util::COLOR_RED, arg, color_util::COLOR_RESET);
                        os::exit(EXIT_FAILURE);
                    }
                    self.options[j].value = self.args[i + 1];
                    i++;
                } else
                {
                    self.options[j].value = arg;
                }
                break;
            }
        }
    }

    for (int i = 0; i < self.options.len; i++)
    {
        if (self.options[i].required && self.options[i].value == "")
        {
            io::eprintfn("%sOption '--%s' is required%s", color_util::COLOR_RED, self.options[i].long_name, color_util::COLOR_RESET);
            os::exit(EXIT_FAILURE);
        }
    }
}

fn void ArgParser.print_usage(&self)
{
    io::printfn("Usage: %s [OPTIONS]", self.args[0]);
    io::printn();
    io::printn("Options:");

    int max_long_name_len = 0;
    for (int i = 0; i < self.options.len; i++)
    {
        int len = self.options[i].long_name.len;
        if (len > max_long_name_len)
        {
            max_long_name_len = len;
        }
    }

    Option help_option = { .short_name = 'h', .long_name = "help", .description = "Displays this message",  .has_arg = false };

    if (help_option.short_name)
    {
        io::printfn("  -%c, --%-10s  %s", help_option.short_name, help_option.long_name, help_option.description);
    } else
    {
        io::printfn("      --%-10s  %s", help_option.long_name, help_option.description);
    }

    for (int i = 0; i < self.options.len; i++)
    {
        if (self.options[i].short_name)
        {
            io::printfn("  -%c, --%-10s  %s", self.options[i].short_name, self.options[i].long_name, self.options[i].description);
        } else
        {
            io::printfn("      --%-10s  %s", self.options[i].long_name, self.options[i].description);
        }
    }
}
