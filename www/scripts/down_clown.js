$(document).ready(function() {
    function checkScroll() {
        var scrollHeight = $(document).height();
        var scrollPosition = $(window).height() + $(window).scrollTop();
        
        if ((scrollHeight - scrollPosition) / scrollHeight < 0.1) {
            $("#arrowcontainer").addClass('fade-hint');
            // Shiny.setInputValue("scrolledToBottom", true, {priority: "event"});
        } else {
            $("#arrowcontainer").removeClass('fade-hint');
            // Shiny.setInputValue("scrolledToBottom", false, {priority: "event"});
        }
    }

    // Run checkScroll when scrolling
    $(window).on("scroll", checkScroll);

    // Run checkScroll when a tab is clicked (to reset detection)
    $(document).on("shiny:inputchanged", function(event) {
        if (event.name === "tabs") {
            setTimeout(checkScroll, 500);  // Small delay to allow UI to load
        }
    });
});
