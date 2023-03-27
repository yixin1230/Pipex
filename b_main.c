/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_main.c                                           :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 09:11:57 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/27 13:35:01 by yizhang       ########   odam.nl         */
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
		redirect_close_wait(fd[1], fd[0], fd[0], id);
}

void	here_doc_child(int *fd, char *str, char *limiter)
{
	protect_close(fd[0]);
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

void	set_infile(char **argv, char **envp)
{
	pid_t	id;
	int		infile;
	int		fd[2];

	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
		here_doc(argv[2]);
	else
	{
		protect_pipe(fd);
		id = fork();
		if (id < 0)
			print_error(NULL, 1);
		if (id == 0)
		{
			infile = open(argv[1], O_RDONLY);
			if (infile == -1)
				print_error(argv[1], 1);
			redirect_close_run(infile, fd[1], argv[2], envp);
		}
		else
			redirect_close_wait(fd[1], fd[0], fd[0], id);
	}
}

void	redirect_close_wait(int close, int dup, int close2, pid_t id)
{
	protect_close(close);
	protect_dup2(dup, 0);
	protect_close(close2);
	protect_waitpid(id, NULL, 0);
}

/* static void	leaks(void)
{
	system("leaks -q pipex");
}
 */

int	main(int argc, char **argv, char **envp)
{
	int	i;
	int	outfile;

	i = 2;
	if (argc < 5)
		print_error("Error: bad arguments\n", 42);
	if (ft_strncmp(argv[1], "here_doc", 8) != 0 && argc == 5)
		m_pipex(argv, envp);
	set_infile(argv, envp);
	while (++i < argc - 2)
		b_child_process(argv[i], envp);
	if (ft_strncmp(argv[1], "here_doc", 8) == 0)
	{
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_APPEND, 0777);
		if (outfile == -1)
			print_error(argv[argc - 1], 1);
	}
	else
	{
		outfile = open(argv[argc - 1], O_WRONLY | O_CREAT | O_TRUNC, 0777);
		if (outfile == -1)
			print_error(argv[argc - 1], 1);
	}
	b_last_child_process(argv[argc - 2], envp, outfile);
	exit(0);
}
