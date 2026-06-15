<script setup>
definePage({
  meta: {
    action: 'read',
    subject: 'permission',
  },
})

const ability = useAbility()

const headers = [
  { title: 'Action', key: 'action' },
  { title: 'Sujet', key: 'subject' },
  { title: 'Libellé', key: 'label' },
  { title: 'Description', key: 'description' },
  { title: 'Actions', key: 'actions', sortable: false, align: 'end' },
]

const permissions = ref([])
const totalPermissions = ref(0)
const loading = ref(false)
const page = ref(1)
const itemsPerPage = ref(10)
const search = ref('')

const fetchPermissions = async () => {
  loading.value = true
  try {
    const res = await $api('/permissions', {
      query: {
        per_page: itemsPerPage.value,
        page: page.value,
        search: search.value || undefined,
      },
    })

    permissions.value = res.data
    totalPermissions.value = res.total
  }
  catch (err) {
    showSnackbar(err?.data?.errors?.auth || 'Erreur lors du chargement des permissions', 'error')
  }
  finally {
    loading.value = false
  }
}

watch(search, () => {
  page.value = 1
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
  action: '',
  subject: '',
  label: '',
  description: '',
})

const form = ref(emptyForm())

const openCreateDialog = () => {
  isEditing.value = false
  errors.value = {}
  form.value = emptyForm()
  isDialogVisible.value = true
}

const openEditDialog = permission => {
  isEditing.value = true
  errors.value = {}
  form.value = {
    id: permission.id,
    action: permission.action,
    subject: permission.subject,
    label: permission.label || '',
    description: permission.description || '',
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
    action: form.value.action,
    subject: form.value.subject,
    label: form.value.label,
    description: form.value.description,
  }

  try {
    if (isEditing.value) {
      await $api(`/permissions/${form.value.id}`, {
        method: 'PUT',
        body,
        onResponseError({ response }) {
          errors.value = response._data.errors || {}
        },
      })
      showSnackbar('Permission mise à jour avec succès')
    }
    else {
      await $api('/permissions', {
        method: 'POST',
        body,
        onResponseError({ response }) {
          errors.value = response._data.errors || {}
        },
      })
      showSnackbar('Permission créée avec succès')
    }

    isDialogVisible.value = false
    await fetchPermissions()
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
const permissionToDelete = ref(null)
const deleting = ref(false)

const confirmDelete = permission => {
  permissionToDelete.value = permission
  isDeleteDialogVisible.value = true
}

const deletePermission = async () => {
  if (!permissionToDelete.value)
    return

  deleting.value = true
  try {
    await $api(`/permissions/${permissionToDelete.value.id}`, { method: 'DELETE' })
    showSnackbar('Permission supprimée avec succès')
    isDeleteDialogVisible.value = false
    await fetchPermissions()
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
            Permissions
          </h4>
          <p class="text-body-2 text-medium-emphasis mb-0">
            Gérez les permissions disponibles pour les rôles
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
            v-if="ability.can('create', 'permission')"
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
        :items="permissions"
        :items-length="totalPermissions"
        :loading="loading"
        @update:options="fetchPermissions"
      >
        <template #item.action="{ item }">
          <VChip
            size="small"
            color="primary"
            variant="tonal"
            label
          >
            {{ item.action }}
          </VChip>
        </template>

        <template #item.subject="{ item }">
          <VChip
            size="small"
            color="secondary"
            variant="tonal"
            label
          >
            {{ item.subject }}
          </VChip>
        </template>

        <template #item.label="{ item }">
          {{ item.label || '—' }}
        </template>

        <template #item.description="{ item }">
          <span class="text-medium-emphasis">{{ item.description || '—' }}</span>
        </template>

        <template #item.actions="{ item }">
          <div class="d-flex justify-end gap-1">
            <VBtn
              v-if="ability.can('update', 'permission')"
              icon
              variant="text"
              size="small"
              @click="openEditDialog(item)"
            >
              <VIcon icon="tabler-edit" />
            </VBtn>
            <VBtn
              v-if="ability.can('delete', 'permission')"
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
      max-width="600"
      persistent
    >
      <VCard>
        <VCardTitle class="pa-5">
          {{ isEditing ? 'Modifier la permission' : 'Ajouter une permission' }}
        </VCardTitle>
        <VDivider />

        <VCardText class="pa-5">
          <VRow>
            <VCol
              cols="12"
              md="6"
            >
              <AppTextField
                v-model="form.action"
                label="Action"
                placeholder="ex: create, read, update, delete"
                :error-messages="fieldErrors('action')"
              />
            </VCol>
            <VCol
              cols="12"
              md="6"
            >
              <AppTextField
                v-model="form.subject"
                label="Sujet"
                placeholder="ex: user, role, permission"
                :error-messages="fieldErrors('subject')"
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
            <VCol
              cols="12"
              md="6"
            >
              <AppTextField
                v-model="form.description"
                label="Description"
                :error-messages="fieldErrors('description')"
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
          Supprimer la permission
        </VCardTitle>
        <VDivider />
        <VCardText class="pa-5">
          Voulez-vous vraiment supprimer la permission
          <strong>{{ permissionToDelete?.label || `${permissionToDelete?.action} ${permissionToDelete?.subject}` }}</strong> ?
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
            @click="deletePermission"
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
