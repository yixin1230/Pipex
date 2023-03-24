/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_main.c                                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 09:11:57 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/24 10:44:17 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	here_doc(char *limiter)
{
	char	*str;
	int		fd[2];
	pid_t	id;

	str = NULL;
	protect_pipe(fd);
	id = fork();
	if (id < 0)
		print_error(NULL, 1);
	if (id == 0)
		here_doc_child(fd, str, limiter);
	else
	{
		protect_close(fd[1]);
		protect_dup2(fd[0], 0);
		protect_close(fd[0]);
		protect_waitpid(id, NULL, 0);
	}
}

void	here_doc_child(int *fd, char *str, char *limiter)
{
	close(fd[0]);
	while (1)
	{
		str = get_next_line(0);
		if (ft_strncmp(str, limiter, ft_strlen(limiter)) == 0
			&& ft_strlen(limiter) == (ft_strlen(str) - 1))
		{
			free(str);
			protect_close(fd[1]);
			exit(0);
		}
		protect_write(fd[1], str, ft_strlen(str));
		free(str);
	}
}

int	set_infile_outfile(char **argv, int argc, int *infile, int *outfile)
{
	int		i;

	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		i = 3;
		*outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_APPEND, 0777);
		if (*outfile == -1)
			print_error(argv[argc - 1], 1);
		here_doc(argv[2]);
	}
	else
	{
		i = 2;
		*infile = open(argv[1], O_RDONLY, 0777);
		if (*infile == -1)
			print_error(argv[1], 1);
		*outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_TRUNC, 0777);
		if (*outfile == -1)
			print_error(argv[argc - 1], 1);
		protect_dup2(*infile, 0);
	}
	return (i);
}

/* static void	leaks(void)
{
	system("leaks -q pipex");
}
 */

int	main(int argc, char **argv, char **envp)
{
	int	i;
	int	infile;
	int	outfile;

	if (argc < 5)
		print_error("Error: bad arguments\n", 42);
	i = set_infile_outfile(argv, argc, &infile, &outfile);
	while (i < argc - 2)
	{
		b_child_process(argv[i], envp);
		i++;
	}
	b_last_child_process(argv[argc - 2], envp, outfile);
	exit(errno);
}
