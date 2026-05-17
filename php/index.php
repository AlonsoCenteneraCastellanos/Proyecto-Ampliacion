<?php get_header(); ?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WebFusion Digital</title>
    <link rel="stylesheet" href="<?php echo get_stylesheet_uri(); ?>" />
</head>
<body>

<header>
    <h1><a href="<?php echo home_url('/'); ?>">WebFusion Digital</a></h1>
    <nav>
        <a href="#servicios">Servicios</a>
        <a href="#contacto">Contacto</a>
    </nav>
</header>

<main>
    <section id="hero">
        <h2>Webs profesionales para tu negocio</h2>
        <p>Diseño, desarrollo y despliegue automatizado con Docker y WordPress.</p>
        <a href="#contacto">Contáctanos</a>
    </section>

    <section id="servicios">
        <h2>Servicios</h2>
        <ul>
            <li>Diseño web personalizado</li>
            <li>WordPress a medida</li>
            <li>Despliegue automatizado</li>
            <li>Mantenimiento y soporte</li>
        </ul>
    </section>

    <section id="contacto">
        <h2>Contacto</h2>
        <p>Email: <a href="mailto:hola@webfusion.digital">hola@webfusion.digital</a></p>
        <p>Teléfono: +34 91 000 00 00</p>
    </section>
</main>

<footer>
    <p>&copy; <?php echo date('Y'); ?> WebFusion Digital S.L.</p>
</footer>

<?php wp_footer(); ?>
</body>
</html>
