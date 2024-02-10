/** @type {import('tailwindcss').Config} */
export default {
  content: ["./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}"],
  theme: {
    extend: {
      fontFamily: {
        sans: [
          "Avenir",
          "Montserrat",
          "Corbel",
          "URW Gothic",
          "source-sans-pro",
          "sans-serif",
        ],
      },
      colors: {
        primary: "var(--primary)",
        secondary: "var(--secondary)",
        background: "var(--background)",
        accent: "var(--accent)",
        bullets: "var(--bullets)",
        code: "var(--code)",
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            "--tw-prose-body": theme("colors.primary"),
            "--tw-prose-headings": theme("colors.secondary"),
            "--tw-prose-links": theme("colors.accent"),
            "--tw-prose-bold": theme("colors.primary"),
            "--tw-prose-code": theme("colors.primary"),
            "--tw-prose-bullets": theme("colors.bullets"),
            "--tw-prose-counters": theme("colors.bullets"),
            "code::before": { content: "" },
            "code::after": { content: "" },
          },
        },
      }),
    },
  },
  plugins: [require("@tailwindcss/typography")],
};
