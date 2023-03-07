# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <yizhang@student.codam.nl>           +#+                      #
#                                                    +#+                       #
#    Created: 2022/12/01 08:30:47 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/07 14:11:15 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = libftprintf.a
CC = gcc
FLAGS = -Wall -Werror -Wextra
LIBFT = libft/libft.a
SRCS = ft_printf.c ft_utils.c
OBJS = ${SRCS:.c=.o}

all: ${NAME}

${NAME}: ${OBJS} 
	@make -C libft
	@cp ${LIBFT} ${NAME}
	@ar rcs ${NAME} ${OBJS}

${OBJS}: ${SRCS}
	@${CC} ${FLAGS} -c ${SRCS}

clean:
	@rm -rf ${OBJS} 
	@make clean -C libft

fclean: clean
	@rm -rf ${NAME}
	@make fclean -C libft

re:fclean all