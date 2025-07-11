extends SB_EventPlayer
class_name SB_EventPlayerLoginError

enum ERROR {
	DEFAULT,
	EMPTY_PASSWORD,
	WRONG_PASSWORD,
	USER_WITH_NAME_EXISTS,
}

var id: int = ERROR.DEFAULT
