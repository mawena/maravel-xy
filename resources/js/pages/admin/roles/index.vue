<script setup>
definePage({
  meta: {
    action: 'read',
    subject: 'role',
  },
})

const ability = useAbility()

const headers = [
  { title: 'Rôle', key: 'name' },
  { title: 'Description', key: 'description' },
  { title: 'Permissions', key: 'permissions', sortable: false },
  { title: 'Actions', key: 'actions', sortable: false, align: 'end' },
]

const roles = ref([])
const totalRoles = ref(0)
const loading = ref(false)
const page = ref(1)
const itemsPerPage = ref(10)
const search = ref('')

const permissionOptions = ref([])

const fetchRoles = async () => {
  loading.value = true
  try {
    const res = await $api('/roles', {
      query: {
        with_permissions: true,
        per_page: itemsPerPage.value,
        page: page.value,
        search: search.value || undefined,
      },
    })

    roles.value = res.data
    totalRoles.value = res.total
  }
  catch (err) {
    showSnackbar(err?.data?.errors?.auth || 'Erreur lors du chargement des rôles', 'error')
  }
  finally {
    loading.value = false
  }
}

const fetchPermissions = async () => {
  try {
    const res = await $api('/permissions', { query: { paginate: false } })

    permissionOptions.value = res.data.map(permission => ({
      title: permission.label || `${permission.action} ${permission.subject}`,
      value: permission.id,
    }))
  }
  catch {
    permissionOptions.value = []
  }
}

watch(search, () => {
  page.value = 1
  fetchRoles()
})

onMounted(() => {
  fetchPermissions()
})

// ----- Snackbar -----
const snackbar = ref({ show: false, text: '', color: 'success' })

const showSnackbar = (text, color = 'success') => {
  snackbar.value = { show: true, text, color }
}

// ----- Create / Edit dialog -----
const isDialogVisible = ref(false)
const isEditing = ref(false)
const saving = ref(false)
const errors = ref({})

const emptyForm = () => ({
  id: null,
  name: '',
  label: '',
  description: '',
  is_super_admin: false,
  permissions: [],
})

const form = ref(emptyForm())

const openCreateDialog = () => {
  isEditing.value = false
  errors.value = {}
  form.value = emptyForm()
  isDialogVisible.value = true
}

const openEditDialog = role => {
  isEditing.value = true
  errors.value = {}
  form.value = {
    id: role.id,
    name: role.name,
    label: role.label || '',
    description: role.description || '',
    is_super_admin: !!role.is_super_admin,
    permissions: (role.permissions || []).map(permission => permission.id),
  }
  isDialogVisible.value = true
}

const fieldErrors = field => {
  const value = errors.value[field]

  return value ? String(value).split('<br>') : []
}

const submitForm = async () => {
  saving.value = true
  errors.value = {}

  const body = {
    name: form.value.name,
    label: form.value.label,
    description: form.value.description,
    is_super_admin: form.value.is_super_admin,
    permissions: form.value.permissions,
  }

  try {
    if (isEditing.value) {
      await $api(`/roles/${form.value.id}`, {
        method: 'PUT',
        body,
        onResponseError({ response }) {
          errors.value = response._data.errors || {}
        },
      })
      showSnackbar('Rôle mis à jour avec succès')
    }
    else {
      await $api('/roles', {
        method: 'POST',
        body,
        onResponseError({ response }) {
          errors.value = response._data.errors || {}
        },
      })
      showSnackbar('Rôle créé avec succès')
    }

    isDialogVisible.value = false
    await fetchRoles()
  }
  catch (err) {
    if (!Object.keys(errors.value).length)
      showSnackbar(err?.data?.errors?.auth || 'Une erreur est survenue', 'error')
  }
  finally {
    saving.value = false
  }
}

// ----- Delete -----
const isDeleteDialogVisible = ref(false)
const roleToDelete = ref(null)
const deleting = ref(false)

const confirmDelete = role => {
  roleToDelete.value = role
  isDeleteDialogVisible.value = true
}

const deleteRole = async () => {
  if (!roleToDelete.value)
    return

  deleting.value = true
  try {
    await $api(`/roles/${roleToDelete.value.id}`, { method: 'DELETE' })
    showSnackbar('Rôle supprimé avec succès')
    isDeleteDialogVisible.value = false
    await fetchRoles()
  }
  catch (err) {
    showSnackbar(err?.data?.errors?.auth || err?.data?.errors?.id || 'Une erreur est survenue', 'error')
  }
  finally {
    deleting.value = false
  }
}
</script>

<template>
  <div>
    <VCard>
      <VCardText class="d-flex flex-wrap gap-4 align-center justify-space-between">
        <div>
          <h4 class="text-h4 mb-1">
            Rôles
          </h4>
          <p class="text-body-2 text-medium-emphasis mb-0">
            Gérez les rôles et leurs permissions
          </p>
        </div>

        <div class="d-flex gap-4 align-center">
          <AppTextField
            v-model="search"
            placeholder="Rechercher..."
            prepend-inner-icon="tabler-search"
            style="min-width: 220px;"
          />

          <VBtn
            v-if="ability.can('create', 'role')"
            prepend-icon="tabler-plus"
            @click="openCreateDialog"
          >
            Ajouter
          </VBtn>
        </div>
      </VCardText>

      <VDivider />

      <VDataTableServer
        v-model:page="page"
        v-model:items-per-page="itemsPerPage"
        :headers="headers"
        :items="roles"
        :items-length="totalRoles"
        :loading="loading"
        @update:options="fetchRoles"
      >
        <template #item.name="{ item }">
          <div class="d-flex align-center gap-2 py-2">
            <div class="font-weight-medium">
              {{ item.label || item.name }}
            </div>
            <VChip
              v-if="item.is_super_admin"
              size="x-small"
              color="error"
              label
            >
              Super Admin
            </VChip>
          </div>
        </template>

        <template #item.description="{ item }">
          <span class="text-medium-emphasis">{{ item.description || '—' }}</span>
        </template>

        <template #item.permissions="{ item }">
          <div
            v-if="item.is_super_admin"
            class="text-medium-emphasis"
          >
            Toutes les permissions
          </div>
          <div
            v-else
            class="d-flex flex-wrap gap-1"
          >
            <VChip
              v-for="permission in item.permissions"
              :key="permission.id"
              size="small"
              color="primary"
              variant="tonal"
              label
            >
              {{ permission.label || `${permission.action} ${permission.subject}` }}
            </VChip>
            <span
              v-if="!item.permissions?.length"
              class="text-disabled"
            >—</span>
          </div>
        </template>

        <template #item.actions="{ item }">
          <div class="d-flex justify-end gap-1">
            <VBtn
              v-if="ability.can('update', 'role')"
              icon
              variant="text"
              size="small"
              @click="openEditDialog(item)"
            >
              <VIcon icon="tabler-edit" />
            </VBtn>
            <VBtn
              v-if="ability.can('delete', 'role')"
              icon
              variant="text"
              size="small"
              color="error"
              @click="confirmDelete(item)"
            >
              <VIcon icon="tabler-trash" />
            </VBtn>
          </div>
        </template>
      </VDataTableServer>
    </VCard>

    <!-- Create / Edit dialog -->
    <VDialog
      v-model="isDialogVisible"
      max-width="650"
      persistent
    >
      <VCard>
        <VCardTitle class="pa-5">
          {{ isEditing ? 'Modifier le rôle' : 'Ajouter un rôle' }}
        </VCardTitle>
        <VDivider />

        <VCardText class="pa-5">
          <VRow>
            <VCol
              cols="12"
              md="6"
            >
              <AppTextField
                v-model="form.name"
                label="Nom (identifiant)"
                :error-messages="fieldErrors('name')"
              />
            </VCol>
            <VCol
              cols="12"
              md="6"
            >
              <AppTextField
                v-model="form.label"
                label="Libellé"
                :error-messages="fieldErrors('label')"
              />
            </VCol>
            <VCol cols="12">
              <AppTextField
                v-model="form.description"
                label="Description"
                :error-messages="fieldErrors('description')"
              />
            </VCol>
            <VCol cols="12">
              <VSwitch
                v-model="form.is_super_admin"
                label="Super administrateur (tous les droits)"
              />
            </VCol>
            <VCol
              v-if="!form.is_super_admin"
              cols="12"
            >
              <AppSelect
                v-model="form.permissions"
                label="Permissions"
                :items="permissionOptions"
                multiple
                chips
                closable-chips
                :error-messages="fieldErrors('permissions')"
              />
            </VCol>
          </VRow>
        </VCardText>

        <VDivider />
        <VCardActions class="pa-4">
          <VSpacer />
          <VBtn
            variant="tonal"
            color="secondary"
            @click="isDialogVisible = false"
          >
            Annuler
          </VBtn>
          <VBtn
            :loading="saving"
            @click="submitForm"
          >
            {{ isEditing ? 'Enregistrer' : 'Créer' }}
          </VBtn>
        </VCardActions>
      </VCard>
    </VDialog>

    <!-- Delete confirm dialog -->
    <VDialog
      v-model="isDeleteDialogVisible"
      max-width="450"
    >
      <VCard>
        <VCardTitle class="pa-5">
          Supprimer le rôle
        </VCardTitle>
        <VDivider />
        <VCardText class="pa-5">
          Voulez-vous vraiment supprimer le rôle <strong>{{ roleToDelete?.label || roleToDelete?.name }}</strong> ?
          Cette action est irréversible.
        </VCardText>
        <VDivider />
        <VCardActions class="pa-4">
          <VSpacer />
          <VBtn
            variant="tonal"
            color="secondary"
            @click="isDeleteDialogVisible = false"
          >
            Annuler
          </VBtn>
          <VBtn
            color="error"
            :loading="deleting"
            @click="deleteRole"
          >
            Supprimer
          </VBtn>
        </VCardActions>
      </VCard>
    </VDialog>

    <VSnackbar
      v-model="snackbar.show"
      :color="snackbar.color"
      location="bottom end"
    >
      {{ snackbar.text }}
    </VSnackbar>
  </div>
</template>
