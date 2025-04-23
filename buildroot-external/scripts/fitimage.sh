#!/bin/bash -e

function fitimage() {
	TARGET_IMG="$1"
	ITS="$2"
	KERNEL_IMG="$3"
	KERNEL_DTB="$4"

	if [ ! -f "$ITS" ]; then
		echo "$ITS not exists!"
		exit 1
	fi

	TMP_ITS=$(mktemp)
	cp "$ITS" "$TMP_ITS"

	sed -i -e "s~@KERNEL_DTB@~$(realpath -q "$KERNEL_DTB")~" \
		-e "s~@KERNEL_IMG@~$(realpath -q "$KERNEL_IMG")~" "$TMP_ITS"

	${BINARIES_DIR}/mkimage -f "$TMP_ITS"  -E -p 0x800 "$TARGET_IMG"
}
