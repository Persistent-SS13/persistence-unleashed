#define MIX					1 << 0
#define FRYER				1 << 1
#define OVEN				1 << 2
#define SKILLET				1 << 3
#define SAUCEPAN			1 << 4
#define POT					1 << 5

// Cooking misc.
// can_insert return values
#define CANNOT_INSERT		0
#define CAN_INSERT			1
#define INSERT_GRABBED		2
// check_contents return values
#define CONTAINER_EMPTY		0
#define CONTAINER_SINGLE	1
#define CONTAINER_MANY		2
