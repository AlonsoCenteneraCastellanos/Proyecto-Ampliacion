<?php
function webfusion_setup() {
    add_theme_support('title-tag');
}
add_action('after_setup_theme', 'webfusion_setup');

function webfusion_styles() {
    wp_enqueue_style('webfusion-style', get_stylesheet_uri());
}
add_action('wp_enqueue_scripts', 'webfusion_styles');
