# azure-infra

azure-infra/
├── modules/
│   └── vnet/                  # Your reusable VNet module (from previous task)
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   ├── staging/
│   └── prod/
├── global/
│   └── naming.tf              # Central naming conventions
├── .github/
│   └── workflows/
│       └── deploy.yml
└── README.md

# Configurable Parameters
Address space

Subnets

NSG creation and associations

Region and tags

# 🔐 Optional Enhancements for Security
NSG rules (customizable)

NSG Flow Logs (with Network Watcher)

Private endpoints

Subnet delegation
