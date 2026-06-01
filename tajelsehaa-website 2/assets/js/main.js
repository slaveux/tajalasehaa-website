(function () {
  'use strict';

  // ── CONFIG ──
  const PARALLAX_SPEED = 0.3;
  const IS_MOBILE = window.innerWidth <= 768;

  // ── SCROLL REVEAL (IntersectionObserver) ──
  function initReveal() {
    const io = new IntersectionObserver((entries) => {
      for (const e of entries) {
        if (e.isIntersecting) {
          e.target.classList.add('in');
          io.unobserve(e.target);
        }
      }
    }, { threshold: 0.08 });

    // Standard upward reveals
    document.querySelectorAll('.block-head, .why-card, .program, .quote-card, .tech-card, .hl, .faq-item, .contact-info, .contact-map').forEach(el => {
      el.classList.add('reveal');
      io.observe(el);
    });

    // Staggered service cards
    const servicesGrid = document.querySelector('.services-grid');
    if (servicesGrid) {
      servicesGrid.classList.add('stagger');
      servicesGrid.querySelectorAll('.service-card').forEach(el => {
        el.classList.add('reveal');
        io.observe(el);
      });
    }

    // Staggered why cards
    const whyGrid = document.querySelector('.why-grid');
    if (whyGrid) {
      whyGrid.classList.add('stagger');
    }

    // Staggered tech cards
    const techGrid = document.querySelector('.tech-grid');
    if (techGrid) {
      techGrid.classList.add('stagger');
    }

    // Directional reveals — about section
    const aboutImgs = document.querySelector('.about-imgs');
    if (aboutImgs) {
      aboutImgs.classList.add('reveal-right');
      io.observe(aboutImgs);
    }

    // Scale reveal — hero visual
    const heroVisual = document.querySelector('.hero-visual');
    if (heroVisual && !IS_MOBILE) {
      heroVisual.classList.add('reveal-scale');
      io.observe(heroVisual);
    }

    // CTA banner
    const ctaBanner = document.querySelector('.cta-banner');
    if (ctaBanner) {
      ctaBanner.classList.add('reveal-scale');
      io.observe(ctaBanner);
    }
  }

  // ── HERO PARALLAX ──
  function initParallax() {
    if (IS_MOBILE) return;

    const hero = document.querySelector('.hero');
    const heroVisualEl = document.querySelector('.hero-visual');
    const heroText = document.querySelector('.hero-text');
    const whyStrip = document.querySelector('.why-strip-wrap');

    if (!hero) return;

    let ticking = false;

    function onScroll() {
      if (ticking) return;
      ticking = true;

      requestAnimationFrame(() => {
        const scrollY = window.pageYOffset;
        const heroH = hero.offsetHeight;

        // Only compute when hero area is in view
        if (scrollY < heroH * 1.5) {
          // Hero image moves up slower (parallax)
          if (heroVisualEl) {
            heroVisualEl.style.transform = 'translateY(' + (scrollY * PARALLAX_SPEED) + 'px)';
          }

          // Hero text fades and shifts up
          if (heroText) {
            const ratio = Math.min(scrollY / (heroH * 0.5), 1);
            heroText.style.opacity = 1 - ratio;
            heroText.style.transform = 'translateY(' + (-scrollY * 0.15) + 'px)';
          }

          // Why-strip subtle horizontal drift
          if (whyStrip && scrollY > hero.offsetTop) {
            const drift = (scrollY - hero.offsetTop) * 0.05;
            whyStrip.style.transform = 'translateX(' + drift + 'px)';
          }
        }

        ticking = false;
      });
    }

    window.addEventListener('scroll', onScroll, { passive: true });
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
