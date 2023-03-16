/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_main.c                                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 09:11:57 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/13 16:37:20 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	here_doc(char *limiter);

void	here_doc(char *limiter)
{
	char	*str;
	int		fd[2];
	pid_t	id;

	str = NULL;
	if (pipe(fd) == -1)
		print_error("0", 0);
	id = fork();
	if (id < 0)
		print_error("0", 0);
	if (id == 0)
	{
		close(fd[0]);
		while (1)
		{
			str = get_next_line(0);
			if (ft_strncmp(str, limiter, ft_strlen(limiter)) == 0
				&& ft_strlen(limiter) == (ft_strlen(str) - 1))
			{
				free(str);
				close(fd[1]);
				exit(0);
			}
			write(fd[1], str, ft_strlen(str));
			free(str);
		}
	}
	else
	{
		waitpid(id, NULL, 0);
		close(fd[1]);
		dup2(fd[0], 0);
		close(fd[0]);
		exit(0);
	}
}

int	main(int argc, char **argv, char **envp)
{
	int	infile;
	int	outfile;
	int	i;

	if (argc < 5)
	{
		ft_putstr_fd("Error: Bad arguments\n", 2);
		exit(1);
	}
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		i = 3;
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_APPEND, 0777);
		here_doc(argv[2]);
	}
	else
	{
		i = 2;
		infile = open(argv[1], O_RDONLY, 0777);
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_TRUNC, 0777);
		dup2(infile, 0);
	}
	while (i < argc - 2)
	{
		b_child_process(argv[i], envp);
		i++;
	}
	dup2(outfile, 1);
	run(argv[argc - 2], envp);
	close(outfile);
	exit(0);
}
