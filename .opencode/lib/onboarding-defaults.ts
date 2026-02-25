export type OnboardingMode = "manual" | "juiceshop-defaults" | "badstore-defaults"

export type OnboardingContact = {
  name: string
  role: string
  phone: string
  email: string
}

export type OnboardingDefaults = {
  run: {
    target_url: string
    target_name: string
    assessment_type: string
    test_environment: string
    assessor_org: string
    assessor_name: string
    assessor_email: string
    client_name: string
  }
  summary: {
    information_base: string
    summary_text: string
  }
  exec: {
    subject_description: string
    scope_targets_markdown: string
    methodology_details: string
    events: string
  }
  appendix: {
    appendix_a: string
    appendix_b: string
  }
  assessorContacts: OnboardingContact[]
  clientContacts: OnboardingContact[]
}

export const onboardingBaseline: OnboardingDefaults = {
  run: {
    target_url: "https://app.acme.com",
    target_name: "Acme Web Application",
    assessment_type: "an external",
    test_environment: "staging environment mirroring production at `https://app.acme.com`.",
    assessor_org: "OpenHack Security Agent",
    assessor_name: "John Doe",
    assessor_email: "john.doe@example.com",
    client_name: "Acme Corp.",
  },
  summary: {
    information_base: "",
    summary_text: "",
  },
  exec: {
    subject_description: "",
    scope_targets_markdown: "",
    methodology_details: "",
    events: "",
  },
  appendix: {
    appendix_a: "",
    appendix_b: "",
  },
  assessorContacts: [{ name: "John Doe", role: "Lead Security Consultant", phone: "+1 555 123 4567", email: "john.doe@example.com" }],
  clientContacts: [{ name: "Jane Smith", role: "Security Lead", phone: "+1 555 987 6543", email: "jane.smith@acme.com" }],
}

export const onboardingDefaults = {
  manual: {
    run: {
      target_url: "",
      target_name: "",
      assessment_type: "",
      test_environment: "",
      assessor_org: "",
      assessor_name: "",
      assessor_email: "",
      client_name: "",
    },
    summary: {
      information_base: "",
      summary_text: "",
    },
    exec: {
      subject_description: "",
      scope_targets_markdown: "",
      methodology_details: "",
      events: "",
    },
    appendix: {
      appendix_a: "",
      appendix_b: "",
    },
    assessorContacts: [],
    clientContacts: [],
  } satisfies OnboardingDefaults,
  juiceshop: {
    run: {
      target_url: "localhost:3333",
      target_name: "OWASP Juice Shop v19.1.1",
      assessment_type: "an external",
      test_environment: "a local instance of the application at `localhost:3333` in a dedicated test environment.",
      assessor_org: "OpenHack Security Agent",
      assessor_name: "Tim Schnepf",
      assessor_email: "security@openhack.com",
      client_name: "The OWASP Foundation, Inc.",
    },
    summary: {
      information_base: "",
      summary_text: "",
    },
    exec: {
      subject_description: "",
      scope_targets_markdown: "",
      methodology_details: "",
      events: "",
    },
    appendix: {
      appendix_a: "",
      appendix_b: "",
    },
    assessorContacts: [
      { name: "Jane Doe", role: "Lead Security Consultant", phone: "+1 555 123 4567", email: "jane.doe@openhack.sec" },
      { name: "John Smith", role: "Security Consultant", phone: "+1 555 234 5678", email: "john.smith@openhack.sec" },
    ],
    clientContacts: [{ name: "Bjoern Kimminich", role: "Project Lead", phone: "+1 555 345 6789", email: "bjoern.kimminich@owasp.org" }],
  } satisfies OnboardingDefaults,
  badstore: {
    run: {
      target_url: "http://localhost:3336",
      target_name: "BadStore.net v1.2.3s",
      assessment_type: "an external",
      test_environment: "a local instance of the application at `http://localhost:3336` in a dedicated test environment.",
      assessor_org: "OpenHack Security Agent",
      assessor_name: "Tim Schnepf",
      assessor_email: "security@openhack.com",
      client_name: "Spi Dynamics (BadStore.net)",
    },
    summary: {
      information_base: "",
      summary_text: "",
    },
    exec: {
      subject_description: "",
      scope_targets_markdown: "",
      methodology_details: "",
      events: "",
    },
    appendix: {
      appendix_a: "",
      appendix_b: "",
    },
    assessorContacts: [
      { name: "Jane Doe", role: "Lead Security Consultant", phone: "+1 555 123 4567", email: "jane.doe@openhack.sec" },
      { name: "John Smith", role: "Security Consultant", phone: "+1 555 234 5678", email: "john.smith@openhack.sec" },
    ],
    clientContacts: [{ name: "Richard Roe", role: "Project Lead", phone: "+1 555 345 6789", email: "spam@badstore.net" }],
  } satisfies OnboardingDefaults,
}

export function onboardingDefaultsForMode(mode: OnboardingMode) {
  if (mode === "juiceshop-defaults") return onboardingDefaults.juiceshop
  if (mode === "badstore-defaults") return onboardingDefaults.badstore
  return onboardingDefaults.manual
}
