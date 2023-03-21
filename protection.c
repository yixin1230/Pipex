/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   protection.c                                       :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/20 19:19:44 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/21 09:09:57 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	protect_waitpid(pid_t id, int status, int options)
{
	if (waitpid(id, &status, options) == -1)
		print_error("0", 0);
}

void	protect_dup2(int file, int file2)
{
	if (dup2(file, file2) == -1)
		print_error("0", 0);
}

void	protect_close(int file)
{
	if (close(file) == -1)
		print_error("0", 0);
}

void	protect_write(int fd, char *buf, int count)
{
	if (write(fd, buf, count) == -1)
		print_error("0", 0);
}

void	protect_pipe(int fd[2])
{
	if (pipe(fd) == -1)
		print_error("0", 0);
}
