function FilamentTips = GetFilamentsTipLocations(MVAR)
    
        nF = size(MVAR.Filaments.XYCoords,1);
        nF(isempty(MVAR.Filaments.XYCoords)) = 0;
        FilamentTips = zeros(nF,2);
        for f = 1:nF
            FilamentTips(f,:) = MVAR.Filaments.XYCoords{f}(end,:);
        end

end
