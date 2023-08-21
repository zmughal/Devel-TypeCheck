use Opcodes;

use constant +{ map {
		"OP_" . uc($_->[1]) => $_->[0]
	} opcodes() };
use constant {
	OP_max => scalar(opcodes()),
	MAXO   => scalar(opcodes()),
};

unless(defined(&OP_phoney_INPUT_ONLY)) {
    sub OP_phoney_INPUT_ONLY () {	-1;}
}
unless(defined(&OP_phoney_OUTPUT_ONLY)) {
    sub OP_phoney_OUTPUT_ONLY () {	-2;}
}
unless(defined(&OP_IS_SOCKET)) {
    sub OP_IS_SOCKET {
	local($op) = @_;
	eval q((($op) ==  &OP_ACCEPT || ($op) ==  &OP_BIND || ($op) ==  &OP_CONNECT || ($op) ==  &OP_GETPEERNAME || ($op) ==  &OP_GETSOCKNAME || ($op) ==  &OP_GSOCKOPT || ($op) ==  &OP_LISTEN || ($op) ==  &OP_RECV || ($op) ==  &OP_SEND || ($op) ==  &OP_SHUTDOWN || ($op) ==  &OP_SOCKET || ($op) ==  &OP_SOCKPAIR || ($op) ==  &OP_SSOCKOPT));
    }
}
unless(defined(&OP_IS_FILETEST)) {
    sub OP_IS_FILETEST {
	local($op) = @_;
	eval q((($op) ==  &OP_FTATIME || ($op) ==  &OP_FTBINARY || ($op) ==  &OP_FTBLK || ($op) ==  &OP_FTCHR || ($op) ==  &OP_FTCTIME || ($op) ==  &OP_FTDIR || ($op) ==  &OP_FTEEXEC || ($op) ==  &OP_FTEOWNED || ($op) ==  &OP_FTEREAD || ($op) ==  &OP_FTEWRITE || ($op) ==  &OP_FTFILE || ($op) ==  &OP_FTIS || ($op) ==  &OP_FTLINK || ($op) ==  &OP_FTMTIME || ($op) ==  &OP_FTPIPE || ($op) ==  &OP_FTREXEC || ($op) ==  &OP_FTROWNED || ($op) ==  &OP_FTRREAD || ($op) ==  &OP_FTRWRITE || ($op) ==  &OP_FTSGID || ($op) ==  &OP_FTSIZE || ($op) ==  &OP_FTSOCK || ($op) ==  &OP_FTSUID || ($op) ==  &OP_FTSVTX || ($op) ==  &OP_FTTEXT || ($op) ==  &OP_FTTTY || ($op) ==  &OP_FTZERO));
    }
}
1;
