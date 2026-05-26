const adminNav = [
  {
    title: 'Utilisateurs',
    icon: { icon: 'tabler-users' },
    to: 'admin-users',
  },
]

const userNav = [
  {
    title: 'Accueil',
    icon: { icon: 'tabler-home' },
    to: 'index',
  },
]

export default (userData) => {
  return userData?.role === 'admin' ? adminNav : userNav
}
