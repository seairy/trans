function submitForm(formId) {
	$("#" + formId).submit();
}

function hasClass(element, className) {
    var reg = new RegExp('(\\s|^)' + className + '(\\s|$)');
    return element.className.match(reg);
}

function addClass(element, className) {
    if (!hasClass(element, className)) {
        element.className += " " + className;
    }
}

function removeClass(element, className) {
    if (hasClass(element, className)) {
        var reg = new RegExp('(\\s|^)'+className+'(\\s|$)');
        element.className = element.className.replace(reg,' ');
    }
}

function match(string, expression) {
    var reg = new RegExp(expression);
    return string.match(reg);
}

function selectOrDeselectCheckbox(checked, checkboxName) {
	var checkBox = document.getElementsByName(checkboxName);
	for(i = 0; i < checkBox.length; i++) {
		checkBox[i].checked = checked;
	}
}

function selectPopularLanguages(checkboxName) {
	var checkBox = document.getElementsByName(checkboxName);
	for(i = 0; i < checkBox.length; i++) {
		if(checkBox[i].value >= 2 && checkBox[i].value <= 9) {
			checkBox[i].checked = true;
		}
	}
}

function selectUnpopularLanguages(checkboxName) {
	var checkBox = document.getElementsByName(checkboxName);
	for(i = 0; i < checkBox.length; i++) {
		if(checkBox[i].value >= 10) {
			checkBox[i].checked = true;
		}
	}
}