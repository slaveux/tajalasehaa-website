// Reveal-on-scroll
  const io = new IntersectionObserver((entries) => {
    for (const e of entries) if (e.isIntersecting) { e.target.classList.add('in'); io.unobserve(e.target); }
  }, { threshold: 0.08 });
  document.querySelectorAll('.block-head, .service-card, .why-card, .program, .quote-card, .tech-card, .hl').forEach(el => {
    el.classList.add('reveal'); io.observe(el);
  });