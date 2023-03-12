/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_child.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/12 16:23:17 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/12 20:27:41 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	b_child_process(char *argv, char **envp)
{
	int		fd[2];
	pid_t	id;

	if (pipe(fd) == -1)
		print_error("0", 0);
	id = fork();
	if (id == -1)
		print_error("0", 0);
	if (id == 0)
	{
		close(fd[0]);
		dup2(fd[1], 1);
		run(argv, envp);
		close(fd[1]);
	}
	else
	{
		close(fd[1]);
		dup2(fd[0], 0);
		waitpid(id, NULL, 0);
		close(fd[0]);
	}
}