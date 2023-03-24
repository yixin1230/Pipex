/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_child.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/12 16:23:17 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/24 15:35:30 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	b_child_process(char *argv, char **envp)
{
	int		fd[2];
	pid_t	id;

	if (pipe(fd) == -1)
		print_error(NULL, 1);
	id = fork();
	if (id == -1)
		print_error(NULL, 1);
	if (id == 0)
	{
		protect_close(fd[0]);
		protect_dup2(fd[1], 1);
		run(argv, envp);
		protect_close(fd[1]);
	}
	else
		redirect_close_wait(fd[1], fd[0], fd[0], id);
}

void	b_last_child_process(char *argv, char **envp, int fd)
{
	pid_t	id;
	int		status;

	id = fork();
	if (id == -1)
		print_error(NULL, 1);
	if (id == 0)
	{
		protect_dup2(fd, 1);
		run(argv, envp);
		protect_close(fd);
	}
	else
	{
		protect_close(fd);
		protect_waitpid(id, &status, 0);
		exit(WEXITSTATUS(status));
	}
}
