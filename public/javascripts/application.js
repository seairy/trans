function submitForm(formId) {
	$(formId).submit();
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