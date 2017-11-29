module GetItFeatures
  module LoginHelper
    def omniauth_hash
      default_omniauth_hash(default_identities)
    end

    def afc_omniauth_hash
      default_omniauth_hash(afc_identities)
    end

    def ns_ill_omniauth_hash
      ns_omniauth_hash(ns_ill_identities)
    end

    def ns_ezborrow_omniauth_hash
      ns_omniauth_hash(ns_ezborrow_identities)
    end

    def nyush_omniauth_hash
      default_omniauth_hash(nyush_identities)
    end

    def default_omniauth_hash(identities)
      hash = OmniAuth::AuthHash.new(provider: :nyulibraries, uid: 'dev123')
      hash.info = omniauth_info
      hash.extra = omniauth_extra(identities)
      hash
    end

    def ns_omniauth_hash(identities)
      hash = OmniAuth::AuthHash.new(provider: :nyulibraries, uid: 'ns_dev123')
      hash.info = omniauth_info
      hash.extra = omniauth_extra(identities, 'new_school_ldap', 'NS')
      hash
    end

    def omniauth_info
      hash = OmniAuth::AuthHash.new(
        {
          name: 'Dev Eloper',
          nickname: 'Dev',
          email: 'dev.eloper@nyu.edu',
          first_name: 'Dev',
          last_name: 'Eloper'
        }
      )
    end

    def omniauth_extra(identities, provider = 'nyu_shibboleth', institution_code = 'NYU')
      OmniAuth::AuthHash.new(
        {
          provider: provider,
          identities: identities,
          institution_code: institution_code
        }
      )
    end

    def default_identities
      [nyu_shibboleth_identity, aleph_identity]
    end

    def afc_identities
      [nyu_shibboleth_identity, afc_aleph_identity]
    end

    def ns_ill_identities
      [new_school_ldap_identity, ns_ill_aleph_identity]
    end

    def ns_ezborrow_identities
      [new_school_ldap_identity, ns_ezborrow_aleph_identity]
    end

    def nyush_identities
      [nyu_shibboleth_identity, nyush_aleph_identity]
    end

    def nyu_shibboleth_identity
      {provider: 'nyu_shibboleth', uid: 'dev123'}
    end

    def new_school_ldap_identity
      {provider: 'new_school_ldap', uid: 'dev123'}
    end

    def aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '51'
        }
      }
    end

    def nyush_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '20'
        }
      }
    end

    def afc_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '90'
        }
      }
    end

    def ns_ill_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '31'
        }
      }
    end

    def ns_ezborrow_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '33'
        }
      }
    end
  end
end
