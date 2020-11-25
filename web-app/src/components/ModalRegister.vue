<template>
  <v-row justify="center">
    <v-dialog
      v-model="dialog"
      persistent
      max-width="500px"
    >
      <v-card>
        <v-card-title>
          <span class="headline">Welcome to Snake game</span>
        </v-card-title>
        <form>
          <v-card-text>
            <p>Create a nickname to play!</p>
            <v-text-field
              v-model="user.nickname"
              :error-messages="nicknameErrors"
              :counter="10"
              label="Nickname"
              required
              @input="$v.user.nickname.$touch()"
              @blur="$v.user.nickname.$touch()"
            ></v-text-field>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn
              class="px-4"
              large
              color="primary"
              @click="submit"
            >
              Go to play
            </v-btn>
          </v-card-actions>
        </form>
      </v-card>
    </v-dialog>
  </v-row>
</template>
<script>
import { validationMixin } from 'vuelidate';
import { required, maxLength } from 'vuelidate/lib/validators';

export default {
  name: 'ModalRegister',
  mixins: [validationMixin],

  validations: {
    user: {
      nickname: { required, maxLength: maxLength(10) },
    },
  },

  data: () => ({
    dialog: true,
    user: {
      nickname: '',
      score: 0,
    },
  }),

  computed: {
    nicknameErrors() {
      const errors = [];
      if (!this.$v.user.nickname.$dirty) return errors;
      // eslint-disable-next-line
      !this.$v.user.nickname.maxLength && errors.push('nickname must be at most 10 characters long');
      // eslint-disable-next-line
      !this.$v.user.nickname.required && errors.push('nickname is required.');
      return errors;
    },
  },

  methods: {
    submit() {
      this.$v.$touch();
      if (this.user.nickname) {
        this.dialog = false;
        this.$store.commit('SET_USER', this.user);
      }
    },
    clear() {
      this.$v.$reset();
      this.user.nickname = '';
    },
  },
};
</script>
