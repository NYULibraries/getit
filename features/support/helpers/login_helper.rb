module GetItFeatures
  module LoginHelper
    def omniauth_hash
      default_omniauth_hash(default_identities)
    end

    def afc_omniauth_hash
      default_omniauth_hash(afc_identities)
    end

    def ns_omniauth_hash
      default_omniauth_hash(ns_identities)
    end

    def default_omniauth_hash(identities)
      hash = OmniAuth::AuthHash.new(provider: :nyulibraries, uid: 'dev123')
      hash.info = omniauth_info
      hash.extra = omniauth_extra(identities)
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

    def omniauth_extra(identities)
      OmniAuth::AuthHash.new(
        {
          provider: 'nyu_shibboleth',
          identities: identities,
          institution_code: 'NYU'
        }
      )
    end

    def default_identities
      [nyu_shibboleth_identity, aleph_identity]
    end

    def afc_identities
      [nyu_shibboleth_identity, afc_aleph_identity]
    end

    def ns_identities
      [nyu_shibboleth_identity, ns_aleph_identity]
    end

    def nyu_shibboleth_identity
      {provider: 'nyu_shibboleth', uid: 'dev123'}
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

    def afc_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '90'
        }
      }
    end

    def ns_aleph_identity
      {
        provider: 'aleph',
        uid: (ENV['BOR_ID'] || 'BOR_ID'),
        properties: {
          patron_status: '37'
        }
      }
    end
  end
end
