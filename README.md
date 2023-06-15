<h1 align="center">  Pipex </h1>

<h2 align="center">Build a network of processes and connecting pipes - and have them act like a single process.

</h2>
<br>
<p align="center">
<p align="center">

  <img alt="Github top language" src="https://img.shields.io/github/languages/top/yixin1230/Minishell?color=3de069">

  <img alt="Github language count" src="https://img.shields.io/github/languages/count/yixin1230/Minishell?color=3de069">

  <img alt="Repository size" src="https://img.shields.io/github/repo-size/yixin1230/Minishell?color=3de069">


</p>

## About

A project made in accordance with the Pipex project which is part of the Codam Core Curriculum.
This program takes the infile, outfile to redirect the STDIN (<), STDOUT (>) and 2 commands to pipe. To execute the mandatory program, type the command listed below. The arguments will be processed as same as < infile cmd1 | cmd2 > outfile on the shell.

## Starting
```bash

# Compile the mandatory part
make

# Compile the bonus part
make bonus
  
# To execute
./pipex <infile> <cmd1> <cmd2> <outfile>

# To remove objects
make clean

# To remove objects and executable
make fclean
```
