/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   find_path.c                                        :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/07 10:28:16 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/07 13:55:09 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	run(char *argv, char **envp);
char	*find_path(char **cmd, char **envp);
void	print_error(void);

void	print_error(void)
{
	perror("Error");
	exit(1);
}

char	*find_path(char **cmd, char **envp)
{
	int		i;
	char	*path;
	char	*path_undone;
	char	**envp_paths;

	i = 0;
	while (ft_strnstr(envp[i], "PATH", 4) == NULL)
		i++;
	envp_paths = ft_split(envp[i] + 5, ':');
	i = 0;
	while (envp_paths[i])
	{
		path_undone = ft_strjoin(envp_paths[i], "/");
		path = ft_strjoin(path_undone, cmd[0]);
		free(path_undone);
		if (access(path, F_OK) == 0)
			return (path);
		free(path);
		i++;
	}
	i = 0;
	if (envp_paths)
	{
		while (envp_paths[i])
		{
			free(envp_paths[i]);
			i++;
		}
		free(envp_paths);
	}
	return (NULL);
}

void	run(char *argv, char **envp)
{
	char	**cmd;
	char	*path;

	cmd = ft_split(argv, ' ');
	path = find_path(cmd, envp);
	if (!path)
		print_error();
	if (execve(path, cmd, envp) == -1)
		print_error();
}
