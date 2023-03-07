/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/07 13:48:28 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

//child_process()//open the infile as input + cmd1 -> end[1] as output
//end[1] pipe end[0] 
//parent_process()//end[0] as input + cmd2 -> outfile as output

void	child_process(int *fd, char **argv, char **envp)
{
	int	infile;

	//close(fd[0]);
	infile = open(argv[1], O_RDONLY, 0777);
	if (infile == -1)
		print_error();
	dup2(infile, 0);
	dup2(fd[1], 1);
	
	close(fd[1]);
	run(argv[2], envp);
}

void	parent_process(int *fd, char **argv, char **envp)
{
	int	outfile;

	//close(fd[1]);
	outfile = open(argv[4], O_RDONLY | O_CREAT, 0777);
	if (outfile == -1)
		print_error();
	dup2(fd[0], 0);
	dup2(outfile, 1);
	
	close(fd[1]);
	run(argv[3], envp);
}

int	main(int argc, char **argv, char **envp)
{
	pid_t	id;
	int		fd[2];

	if (argc != 5 )
		print_error();
	if (pipe(fd) == -1)
		print_error();
	id = fork();
	if (id == -1)
		print_error();
	if (id == 0)
		child_process(fd, argv, envp);
	waitpid(id, NULL, 0);
	parent_process(fd, argv, envp);
	return (0);
}
