function [indices] = GetNeighbors(M, EP, prior, i, q, tau)
	% get q closest
	dists = zeros(1, M);
	for j=1:M
		dists(j) = norm((EP(i) - EP(j))')^2;
	end
	dists = sqrt(dists);
	[sorted,I] = sort(dists);
	
	indices = I(1:q);
	hist = ones(1,10) * tau;
	% filter by tau
	for k=1:q
		j = indices(k);
		Tdif = abs(prior(j) - prior(k));
        ratio = Tdif / sorted(j);
		if(ratio < mean(hist))
			indices(k) = 0;
        end
        hist(randi([1 10], 1, 1)) = ratio;
	end
	
	
	indices = nonzeros(indices);
end
