const menuButton = document.querySelector("[data-menu-button]");
const nav = document.querySelector("[data-nav]");

menuButton?.addEventListener("click", () => {
  const open = menuButton.getAttribute("aria-expanded") === "true";
  menuButton.setAttribute("aria-expanded", String(!open));
  nav?.classList.toggle("is-open", !open);
});

nav?.querySelectorAll("a").forEach((link) => {
  link.addEventListener("click", () => {
    menuButton?.setAttribute("aria-expanded", "false");
    nav.classList.remove("is-open");
  });
});

const observer = "IntersectionObserver" in window
  ? new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          entry.target.classList.add("is-visible");
          observer.unobserve(entry.target);
        }
      });
    }, { threshold: 0.12 })
  : null;

document.querySelectorAll(".reveal").forEach((element) => {
  if (observer) observer.observe(element);
  else element.classList.add("is-visible");
});

document.querySelectorAll("[data-form='waitlist']").forEach((form) => {
  form.addEventListener("submit", async (event) => {
    event.preventDefault();
    const email = form.elements.email;
    const status = form.querySelector(".form-status");
    const button = form.querySelector("button[type='submit']");
    status.classList.remove("is-error");

    if (!email.validity.valid) {
      status.textContent = "請輸入有效的 Email。";
      status.classList.add("is-error");
      email.focus();
      return;
    }

    button.disabled = true;
    button.textContent = "送出中…";
    try {
      const response = await fetch("/api/waitlist", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: email.value, source: form.dataset.source })
      });
      const result = await response.json();
      if (!response.ok) throw new Error(result.message);
      status.textContent = "收到！App 開放測試時會第一時間通知你。";
      email.value = "";
      button.textContent = "已加入名單";
    } catch (error) {
      status.textContent = error.message || "暫時無法送出，請稍後再試。";
      status.classList.add("is-error");
      button.disabled = false;
      button.textContent = "加入測試名單";
    }
  });
});

const supportForm = document.querySelector("[data-form='support']");
supportForm?.addEventListener("submit", async (event) => {
  event.preventDefault();
  const status = supportForm.querySelector(".form-status");
  const button = supportForm.querySelector("button[type='submit']");
  const data = new FormData(supportForm);
  status.classList.remove("is-error");
  button.disabled = true;
  button.textContent = "送出中…";

  try {
    const response = await fetch("/api/support", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(Object.fromEntries(data.entries()))
    });
    const result = await response.json();
    if (!response.ok) throw new Error(result.message);
    supportForm.reset();
    status.textContent = result.message;
    button.textContent = "已送出";
  } catch (error) {
    status.textContent = error.message || "暫時無法送出，請稍後再試。";
    status.classList.add("is-error");
    button.disabled = false;
    button.textContent = "送出訊息";
  }
});
