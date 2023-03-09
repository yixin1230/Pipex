/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   main.c                                             :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <zhaozicen951230@gmail.com>          +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/03 15:37:21 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/09 16:04:21 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	child_process(int *fd, char **argv, char **envp);
void	parent_process(int *fd, char **argv, char **envp);

void	child_process(int *fd, char **argv, char **envp)
{
	int	infile;

	close(fd[0]);
	infile = open(argv[1], O_RDONLY, 0777);
	if (infile == -1)
	{
		ft_putstr_fd("permission denied: ", 2);
		ft_putstr_fd(argv[1], 2);
		exit(1);
	}
	dup2(fd[1], 1);
	dup2(infile, 0);
	close(fd[0]);
	run(argv[2], envp);
}

void	parent_process(int *fd, char **argv, char **envp)
{
	int	outfile;

	close(fd[1]);
	outfile = open(argv[4], O_WRONLY | O_CREAT | O_TRUNC, 0777);
	if (outfile == -1)
	{
		ft_putstr_fd("permission denied: ", 2);
		ft_putstr_fd(argv[4], 2);
		exit(1);
	}
	dup2(fd[0], 0);
	dup2(outfile, 1);
	close(fd[1]);
	run(argv[3], envp);
}

int	main(int argc, char **argv, char **envp)
{
	pid_t	id;
	int		fd[2];

	if (argc != 5)
		print_error();
	pipe(fd);
	id = fork();
	if (id == -1)
		print_error();
	if (id == 0)
		child_process(fd, argv, envp);
	waitpid(id, NULL, 0);
	parent_process(fd, argv, envp);
	return (0);
}
