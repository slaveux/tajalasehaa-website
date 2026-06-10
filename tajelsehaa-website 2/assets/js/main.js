(function () {
  'use strict';

  // ── CONFIG ──
  const PARALLAX_SPEED = 0.3;

  const reducedMotion =
    window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function isMobile() {
    return window.innerWidth <= 768;
  }

  function inViewport(el) {
    const r = el.getBoundingClientRect();
    return r.top < window.innerHeight && r.bottom > 0;
  }

  // ── SCROLL REVEAL (IntersectionObserver) ──
  function initReveal() {
    if (!('IntersectionObserver' in window) || reducedMotion) return;

    const io = new IntersectionObserver((entries) => {
      for (const e of entries) {
        if (e.isIntersecting) {
          e.target.classList.add('in');
          io.unobserve(e.target);
        }
      }
    }, { threshold: 0.08 });

    // Never hide elements already on screen (prevents first-paint flash)
    function reveal(el, cls) {
      if (inViewport(el)) return;
      el.classList.add(cls);
      io.observe(el);
    }

    // Standard upward reveals
    document.querySelectorAll('.block-head, .why-card, .program, .quote-card, .tech-card, .hl, .faq-item, .contact-info, .contact-map').forEach(el => {
      reveal(el, 'reveal');
    });

    // Staggered service cards
    const servicesGrid = document.querySelector('.services-grid');
    if (servicesGrid) {
      servicesGrid.classList.add('stagger');
      servicesGrid.querySelectorAll('.service-card').forEach(el => reveal(el, 'reveal'));
    }

    // Staggered why / tech cards
    const whyGrid = document.querySelector('.why-grid');
    if (whyGrid) whyGrid.classList.add('stagger');
    const techGrid = document.querySelector('.tech-grid');
    if (techGrid) techGrid.classList.add('stagger');

    // Directional reveals — about section
    const aboutImgs = document.querySelector('.about-imgs');
    if (aboutImgs) reveal(aboutImgs, 'reveal-right');

    // Scale reveal — hero visual
    const heroVisual = document.querySelector('.hero-visual');
    if (heroVisual && !isMobile()) reveal(heroVisual, 'reveal-scale');

    // CTA banner
    const ctaBanner = document.querySelector('.cta-banner');
    if (ctaBanner) reveal(ctaBanner, 'reveal-scale');
  }

  // ── HERO PARALLAX (cached layout reads — no per-frame reflow) ──
  function initParallax() {
    if (isMobile() || reducedMotion) return;

    const hero = document.querySelector('.hero');
    if (!hero) return;

    const heroVisualEl = document.querySelector('.hero-visual');
    const heroText = document.querySelector('.hero-text');
    const whyStrip = document.querySelector('.why-strip-wrap');

    let heroH = hero.offsetHeight;
    let heroTop = hero.offsetTop;
    let active = true;
    let ticking = false;

    function onResize() {
      active = !isMobile();
      heroH = hero.offsetHeight;
      heroTop = hero.offsetTop;
      if (!active) {
        if (heroVisualEl) heroVisualEl.style.transform = '';
        if (heroText) { heroText.style.opacity = ''; heroText.style.transform = ''; }
        if (whyStrip) whyStrip.style.transform = '';
      }
    }

    function onScroll() {
      if (ticking || !active) return;
      ticking = true;

      requestAnimationFrame(() => {
        const scrollY = window.pageYOffset;

        if (scrollY < heroH * 1.5) {
          if (heroVisualEl) {
            heroVisualEl.style.transform = 'translate3d(0,' + (scrollY * PARALLAX_SPEED) + 'px,0)';
          }
          if (heroText) {
            const ratio = Math.min(scrollY / (heroH * 0.5), 1);
            heroText.style.opacity = 1 - ratio;
            heroText.style.transform = 'translate3d(0,' + (-scrollY * 0.15) + 'px,0)';
          }
          if (whyStrip && scrollY > heroTop) {
            const drift = (scrollY - heroTop) * 0.05;
            whyStrip.style.transform = 'translate3d(' + drift + 'px,0,0)';
          }
        }

        ticking = false;
      });
    }

    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('resize', onResize, { passive: true });
  }

  // ── INIT ──
  function init() {
    initReveal();
    initParallax();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
