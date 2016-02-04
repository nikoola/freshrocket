
shared_context 'shared_headers' do
	let(:'access-token') { auth_headers['access-token'] }
	let(:'token-type')   { auth_headers['token-type'] }
	let(:'clienty')      { auth_headers['client'] } #because  undefined method `get' for "61IWIQ28jjl6Nqg-JyKSRg":String otherwise
	let(:'expiry')       { auth_headers['expiry'] }
	let(:'uid')          { auth_headers['uid'] }

	header 'access-token', :'access-token'
	header 'token-type',   :'token-type'
	header 'client',       :'clienty'
	header 'expiry',       :'expiry'
	header 'uid',          :'uid'
end