# **************************************************************************** #
#                                                                              #
#                                                         ::::::::             #
#    Makefile                                           :+:    :+:             #
#                                                      +:+                     #
#    By: yizhang <zhaozicen951230@gmail.com>          +#+                      #
#                                                    +#+                       #
#    Created: 2023/03/03 15:44:45 by yizhang       #+#    #+#                  #
#    Updated: 2023/03/09 14:45:56 by yizhang       ########   odam.nl          #
#                                                                              #
# **************************************************************************** #

NAME = pipex
B_NAME = pipex
CC = gcc
FLAG = -Wall -Werror -Wextra
FT_PRINTF = ft_printf/libftprintf.a
SRC = find_path.c
MAIN = main.c 
OBJ = ${SRC:.c=.o}
#B_SRC = 
#B_MAIN = b_main.c
#B_OBJ = ${B_SRC.c=.o}

all: ${NAME}

#bonus: ${B_NAME}

${NAME}: ${MAIN} ${FT_PRINTF} ${OBJ}
		@${CC} ${FLAG} ${FT_PRINTF} ${OBJ} ${MAIN} -o ${NAME}

${OBJ}: ${SRC}
		@${CC} ${FLAG} -c ${SRC}

#${B_NAME}: ${B_MAIN} ${FT_PRINTF} ${B_OBJ}
#		@${CC} ${FLAG} ${FT_PRINTF} ${B_OBJ} ${MAIN} -o ${B_NAME}

#${B_OBJ}: ${B_SRC}
#		@${CC} ${FLAG} -c ${B_SRC}

${FT_PRINTF}:
	@make -C ft_printf

clean:
	@rm -rf ${OBJ}
	@rm -rf ${B_OBJ}
	@make clean -C ft_printf

fclean:clean
	@rm -rf ${NAME}
	@rm -rf ${B_NAME}
	@make fclean -C ft_printf

re:fclean all

.PHONY: all clean fclean re bonus
