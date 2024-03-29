# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <zhaozicen951230@gmail.com>          +#+                      #
#                                                    +#+                       #
#    Created: 2023/03/03 15:44:45 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/21 09:06:43 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = pipex
B_NAME = pipex
CC = gcc
FLAG = -Wall -Werror -Wextra
FT_PRINTF = ft_printf/libftprintf.a
SRC = find_path.c main.c ft_p_split.c ft_p_strjoin.c protection.c
B_SRC = find_path.c b_main.c b_child.c b_utils.c ft_p_split.c ft_p_strjoin.c protection.c
OBJ = ${SRC:.c=.o}
B_OBJ = ${B_SRC:.c=.o}

ifdef BONUS
SRC = $(B_SRC)
endif

all: ${NAME}

bonus:
	@${MAKE} BONUS=1

${NAME}: ${FT_PRINTF} ${OBJ}
		@${CC} ${FLAG} ${OBJ} ${FT_PRINTF} -o ${NAME}

${OBJ}: ${SRC}
		@${CC} ${FLAG} -c ${SRC}

${FT_PRINTF}:
	@make -C ft_printf

clean:
	@rm -rf ${OBJ}
	@rm -rf ${B_OBJ}
	@make clean -C ft_printf

fclean:clean
	@rm -rf ${NAME}
	@make fclean -C ft_printf

re:fclean all

.PHONY: all clean fclean re bonus
