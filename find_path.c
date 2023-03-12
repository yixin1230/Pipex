/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   find_path.c                                        :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/07 10:28:16 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/12 18:40:45 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

void	run(char *argv, char **envp);
char	*find_path(char *cmd, char **envp);
void	print_error(char *str, int i);

void	print_error(char *str, int i)
{
	ft_putstr_fd(strerror(errno), 2);
	if (i)
	{
		ft_putstr_fd(": ", 2);
		ft_putstr_fd(str, 2);
		ft_putstr_fd("\n", 2);
	}
	exit(1);
}

char	*find_path(char *cmd, char **envp)
{
	int		i;
	char	*path;
	char	*path_undone;
	char	**envp_paths;

	i = 0;
	while (ft_strnstr(envp[i], "PATH", 4) == NULL)
		i++;
	envp_paths = ft_split(envp[i] + 5, ':');
	i = -1;
	while (envp_paths[++i])
	{
		path_undone = ft_strjoin(envp_paths[i], "/");
		path = ft_strjoin(path_undone, cmd);
		free(path_undone);
		if (access(path, F_OK) == 0)
			return (path);
		free(path);
	}
	i = -1;
	while (envp_paths[++i])
		free(envp_paths[i]);
	free(envp_paths);
	return (NULL);
}

void	run(char *argv, char **envp)
{
	char	**cmd;
	char	*path;
	int		i;

	i = 0;
	cmd = ft_split(argv, ' ');
	if (access(argv, F_OK) == 0)
		path = argv;
	else
		path = find_path(cmd[0], envp);
	if (!path)
	{
		ft_putstr_fd(strerror(errno), 2);
		ft_putstr_fd(": ", 2);
		ft_putstr_fd(cmd[0], 2);
		ft_putstr_fd("\n", 2);
		while (cmd[i])
		{
			free(cmd[i]);
			i++;
		}
		free(cmd);
		exit(1);
	}
	if (execve(path, cmd, envp) == -1)
		print_error("0", 0);
}
