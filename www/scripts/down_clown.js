$(document).ready(function() {
    function checkScroll() {
        var scrollHeight = $(document).height();
        var scrollPosition = $(window).height() + $(window).scrollTop();
        
        if ((scrollHeight - scrollPosition) < 150) {
            $("#arrowcontainer").addClass('fade-hint');
        } else {
            $("#arrowcontainer").removeClass('fade-hint');
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
