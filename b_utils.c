/* ************************************************************************** */
/*                                                                            */
/*                                                        ::::::::            */
/*   b_utils.c                                          :+:    :+:            */
/*                                                     +:+                    */
/*   By: yizhang <yizhang@student.codam.nl>           +#+                     */
/*                                                   +#+                      */
/*   Created: 2023/03/09 12:30:34 by yizhang       #+#    #+#                 */
/*   Updated: 2023/03/09 13:57:04 by yizhang       ########   odam.nl         */
/*                                                                            */
/* ************************************************************************** */

#include "pipex.h"

char	*get_next_line(void)
{
	int		i;
	char	buff;
	char	*str;

	i = 8;
	while (i)
	{
		i = read(0, &buff, 1);
		if (i < 0)
			return (NULL);
		if (!str)
			str = ft_strdup(buff);
		else
			str = ft_strjoin(str, buff);
		if (ft_strrchr(str, '\n') != NULL)
	}
}