/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/21 19:28:23 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	child_process(int *fd, char **argv, char **envp)
{
	int	infile;

	close(fd[0]);
	infile = open(argv[1], O_RDONLY);
	if (infile == -1)
		print_error(argv[1], 1);
	redirect_close_run(infile, fd[1], argv[2], envp);
}

void	parent_process(int *fd, char **argv, char **envp)
{
	int		outfile;
	pid_t	id;
	int		status;
	int		ret;

	ret = 0;
	close(fd[1]);
	outfile = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (outfile == -1)
		print_error(argv[4], 1);
	id = fork();
	if (id == -1)
		print_error(NULL, 1);
	if (id == 0)
		redirect_close_run(fd[0], outfile, argv[3], envp);
	else
	{
		waitpid(id, &status, 0);
		ret = WIFEXITED(status);
	}
	exit (ret);
}

void	redirect_close_run(int in, int out, char *argv, char **envp)
{
	protect_dup2(in, 0);
	protect_dup2(out, 1);
	run(argv, envp);
	protect_close(in);
}

/* static void	leaks(void)
{
	system("leaks -q pipex");
} */

int	main(int argc, char **argv, char **envp)
{
	pid_t	id;
	int		fd[2];

	//atexit(leaks);
	if (argc != 5)
		print_error("Error: bad arguments\n", 42);
	protect_pipe(fd);
	id = fork();
	if (id == -1)
		print_error(NULL, 1);
	if (id == 0)
		child_process(fd, argv, envp);
	parent_process(fd, argv, envp);
	/* if (waitpid(id, NULL, 0) == -1)
		print_error(NULL, 1); */
	return (0);
}
